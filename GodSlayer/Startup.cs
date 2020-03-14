using GodSlayer.Repositories;
using GodSlayer.Repositories.Interfaces;
using GodSlayer.Services;
using GodSlayer.Services.Interfaces;
using GodSlayer.Utilities;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Oracle.ManagedDataAccess.Client;
using System;

namespace GodSlayer
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IHostingEnvironment environment)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(environment.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddEnvironmentVariables();

            if (environment.IsDevelopment())
            {
                builder.AddUserSecrets<Startup>();
            }

            Configuration = builder.Build();
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddOptions();

            services.Configure<Secrets>(Configuration.GetSection(nameof(Secrets)));

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            services.AddTransient<IKafkaProducerRepository<string, string>, KafkaProducerRepository<string, string>>();
            services.AddTransient<IKafkaAdminClientRepository, KafkaAdminClientRepository>();
            services.AddTransient<IResourceRepository, ResourceRepository>();

            services.AddTransient<IChangeDataCaptureService, ChangeDataCaptureService>();
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseMvc();

            app.Run(async (context) =>
            {
                string connectionString = Configuration.GetSection("Secrets:ConnectionString").Value;

                await context.Response.WriteAsync("Welcome to GodSlayer!\n\n");

                await context.Response.WriteAsync($"Environment: {Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")}\n");
                await context.Response.WriteAsync($"ConnectionString: {connectionString}");
            });
        }
    }
}
