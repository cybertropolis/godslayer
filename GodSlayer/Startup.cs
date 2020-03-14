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
            services.AddTransient<IOracleMonitorRepository, OracleMonitorRepository>();

            services.AddTransient<IChangeDataCaptureService, ChangeDataCaptureService>();
        }
        
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseMvc();

            app.Run(async (context) =>
            {
                await context.Response.WriteAsync($"DB Connection: {Configuration.GetSection("Secrets:ConnectionString")}");
            });
        }
    }
}
