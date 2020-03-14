using GodSlayer.Requests;
using GodSlayer.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;

namespace GodSlayer.Controllers
{
    [Route("api/change-data-capture")]
    [ApiController]
    public class ChangeDataCaptureController : ControllerBase
    {
        IChangeDataCaptureService changeDataCaptureService;

        public ChangeDataCaptureController(IChangeDataCaptureService changeDataCaptureService)
        {
            this.changeDataCaptureService = changeDataCaptureService;
        }

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

        [HttpDelete("{schema}/{table}/{id}")]
        public async Task<IActionResult> Delete([FromRoute] string schema, [FromRoute] string table, [FromRoute] string id)
        {
            await changeDataCaptureService.DeleteAsync(schema, table, id);

            return Ok();
        }
    }
}
