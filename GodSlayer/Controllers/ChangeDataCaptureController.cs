using GodSlayer.Requests;
using GodSlayer.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace GodSlayer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChangeDataCaptureController : ControllerBase
    {
        IChangeDataCaptureService changeDataCaptureService;

        public ChangeDataCaptureController(IChangeDataCaptureService changeDataCaptureService)
        {
            this.changeDataCaptureService = changeDataCaptureService;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] MessageCreateRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await changeDataCaptureService.CreateAsync(request);

            return Ok();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<IActionResult> Update([FromBody] MessageUpdateRequest request)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            await changeDataCaptureService.UpdateAsync(request);

            return Ok();
        }

        /// <summary>
        /// Deleta um registro parmanentemente.
        /// </summary>
        /// <param name="id">Campo identificador do registro.</param>
        /// <returns>
        /// 200 - Retorna o id removido para atualizar os logs.
        /// </returns>
        [HttpDelete("{resource}/{key}")]
        public async Task<IActionResult> Delete(string resource, string key)
        {
            await changeDataCaptureService.DeleteAsync(resource, key);

            return Ok();
        }
    }
}
